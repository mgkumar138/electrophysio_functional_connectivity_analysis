# electrophysio_functional_connectivity_analysis
Functional Connectivity Analysis
by performing Correlation, Coherence, Granger Causality 

Code built for Local Field Potential (LFP) recordings analysis from multi channel electrodes

Aim: To use graph theory to understand local network circuitry by finding common input/common source nodes and information flow within circuitry

Main codes: 
correlation_analysis - perform time based pairwise analysis  
coherence_analysis - perform frequency based pairwise analysis
granger_analysis - utilise variables from coherence analysis adjency matrix
graph_analysis - used in conjunction with code in () create undirected graph(correlation/coherence_analysis) or directed graph(granger_analysis) 
