# Probabilistic-Graphical-Model
Probabilistic Graphical Model for identifying factors that will increase revenue<br><br>
Overall Structure of the PGM system
<p align="center">
<img src="https://github.com/ShwetaSood/Probabilistic-Graphical-Model/blob/master/photos/method.JPG"><br>
</p>
Details on Data Preparation and Network Building
<p align="center">
<img src="https://github.com/ShwetaSood/Probabilistic-Graphical-Model/blob/master/photos/bayesian.JPG"><br>
</p>
Maximum A Posteriori Query (MAP) Process flow<p align="center">
<img src="https://github.com/ShwetaSood/Probabilistic-Graphical-Model/blob/master/photos/MAP.JPG"><br>
</p>
Details of files
<ol type="1">
<li>BayesianNetwork_met.R - creating a Bayesian Network with Tabu Search and BDe (bayesian dirichlet equivalent) scoring function.
Model tries various permutations of adding and removing arcs, such that final network has maximum posterior probability distribution, starting from a prior probability distribution on the possible networks, conditioned on data.
</li>
<li>Data_preparation.R - Pre-processing and binning of data</li>
<li>MAP_Query.java - Select the target variable’s Markov Blanket variables for which MAP values are to be computed. Run MAP query.
This query returns the value of the  selected variables such that the posterior probability of the evidenced target is maximized.
</li>
<li>cart_implement_metdata.R - Equivalent CART (Classification and Regression Trees) visualization of the data for comparison with Bayesian Network</li>
<li>shiny-demo/server.R - creates a server : upload .csv data file and visualize the Markov Blanket of a target variable</li>
<li>shiny-demo/ui.R - UI of the application</li>
<li>shiny-demo/Functions.R - all functions of the server</li>
</ol>
<b> More details about the project in PPT_ADML_PGM_KnowledgeSharing_9JULY2015_v1.pdf <br>
To know about the data refer XLS_ADML_MET004_GAF_MAP_MB_11JUNE2015.xlsx </b>
