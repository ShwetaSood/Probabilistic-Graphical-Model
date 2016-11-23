datapreparation <- function(inp,nlevels = 100) {
  out = as.data.frame(matrix(NA,nrow=nrow(inp)))
  for(var in 1:ncol(inp)){
    temp = as.numeric(inp[,var])
    print(class(temp))
    nlevel = length(unique(inp[,var]))
    if(nlevel > nlevels) nlevel = nlevels
    print(colnames(inp)[var])
    print(nlevel)
    breaks<-c(-Inf, sort(unique(temp)), Inf)
    print(breaks)
    temp_append<-cut(temp,breaks, ordered_result = TRUE)
    out = cbind(out,temp_append)
    colnames(out)[var+1] = colnames(inp)[var]
  }
  out = out[,-1]
  return(out)
}

markov_blanket = function(x,node){
  if(!is.data.frame(x)) x = as.data.frame(x)
  if(ncol(x) != 2) print("Number of Column should be 2 [FROM] [TO]")
  colnames(x) = c("from","to")
  
  child = c()
  index1 = which(x$from == node)
  if(length(index1) > 0) child = as.vector(x$to[index1])
  
  parent = c()
  index2 = which(x$to == node)
  if(length(index2) > 0) parent = as.vector(x$from[index2])
  
  node_sibling = c()
  lst = sapply(child,function(z) x$from[which(x$to==z)])
  node_sibling = as.vector(unique(unlist(lst)))
  
  lst1 = sapply(child,function(z) which(x$to==z))
  index3 = as.vector(unique(unlist(lst1)))
  
  out_index = c(index1,index2,index3)
  
  return(list(child=child,parent=parent,node_sib = node_sibling,index = out_index))
}

plot_markov_blanket = function(x,node){
  if(!is.data.frame(x)) x = as.data.frame(x)
  v1 = x["from"]
  v2 = x["to"]
  colnames(v1)= colnames(v2) =  "vertex"
  vertices = unique(rbind(v1, v2 )$vertex)
  vertices = as.data.frame(vertices)
  colnames(vertices) = "vertex"
  vertices$color = ifelse(vertices$vertex==node, "1", "2")
  nodelist = graph.data.frame(x,  directed=TRUE, vertices=vertices)
  graph = simplify(nodelist)
  V(graph)$color = ifelse(V(graph)$color == 1, "#CC3333",  "#99CCCC")
  plot.igraph(graph, edge.width=3,edge.arrow.size=0.5,edge.arrow.width=0.9,vertex.label.cex=0.7,
              edge.arrow.mode=2,layout=layout.auto,vertex.shape="circle")  
#   plot.igraph(graph, edge.width=3,edge.arrow.size=0.5,edge.arrow.width=0.9,vertex.label.cex=1,
#               edge.arrow.mode=2,layout=layout.auto,vertex.shape="circle")  
}


auc_compute = function(actual,predict){
  if(length(actual) != length(predict)) print("Prediction and Actual of
                                              different length")
  n = length(actual)
  auc_data = as.data.frame(matrix(NA,ncol=2,nrow = n))
  colnames(auc_data) = c("a","p")
  auc_data$a = actual
  auc_data$p = predict
  total = sum(auc_data$a)
  auc_data = auc_data[order(-auc_data$p),]
  intervals = c(seq(1,n,as.integer(n/10)),n+1)
  decile_compute = as.data.frame(matrix(NA,ncol = 4, nrow = 10))
  colnames(decile_compute) = c("count","cum_count","prop","cum_prop")
  for(i in 1:10){
    current_val = sum(auc_data[(intervals[i]:(intervals[i+1]-1)),"a"])
    decile_compute[i,"count"] = current_val
    decile_compute[i,"prop"] = current_val/total
  }
}


information_value = function(predict,target){
  data<-data.frame(predict,target)
  iv = as.data.frame(matrix(NA,nrow = length(unique(predict)),ncol = 7))
  colnames(iv) = c("categories","responder","non_responder","percent_responder","percent_non_responder","woe","iv")
  iv$categories = colnames(table(target,predict))
  iv$responder = table(target,predict)[2,]
  iv$non_responder = table(target,predict)[1,]
  iv$percent_responder = iv$responder/sum(iv$responder)
  iv$percent_non_responder = iv$non_responder/sum(iv$non_responder)
  iv$woe = log(iv$percent_responder/iv$percent_non_responder,base = exp(1))
  iv$iv = (iv$percent_responder - iv$percent_non_responder)*iv$woe
  return(iv)
}


view_user_network = function(network,nodelist){
  user_network_data = data.frame(network$arcs)
  graph = graph.data.frame(user_network_data[user_network_data$from %in% nodelist |user_network_data$to %in% nodelist ,])
  V(graph)$color = ifelse(vertex.attributes(graph)$name %in% nodelist, "#CC3333",  "#99CCCC")
  plot.igraph(graph, edge.width=3,edge.arrow.size=0.5,edge.arrow.width=2,vertex.label.cex=0.7,
              edge.arrow.mode=2,layout=layout.auto,vertex.shape="circle") 
# plot.igraph(graph, edge.width=3,edge.arrow.size=0.5,edge.arrow.width=2,vertex.label.cex=1,
#             edge.arrow.mode=2,layout=layout.fruchterman.reingold(graph,niter=10000,area=30^vcount(graph)^2),vertex.shape="circle")

}