"""
Copyright (c) Microsoft Corporation.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
"""

import pandas as pd
from typing import List

# Provides a basic implementation for evaluating degradation of a metric in a long running experiment
# on an LST (table format). The evaluator takes as in put an ordered list of metric's values collected 
# at various points in time and returns a single value that represents the degradation of the metric 
# over time.
# This implementation evaluates and returns the average degradation rate, evaluated as
# ( summation( (Mi - Mi-1) / Mi-1 ) ) / (n-1) 
# where,
#  Mi is the metric value at time i 
#  n is the number of metric values provided, 
#  and n-1 total differences are calculated
class DegradationEvaluatorBase:
    def evaluate(self, metricValues: List[float]) -> float:
        if len(metricValues) < 2:
            raise ValueError("At least two metric values are needed to evaluate degradation")
        
        # Calculate the degradation rate
        degradationRate = 0.0
        for i in range(1, len(metricValues)):
            degradationRate += (metricValues[i] - metricValues[i-1]) / metricValues[i-1]
        
        return degradationRate / (len(metricValues) - 1)


# This helper class provides utility methods to compute degradation of a metric for a set of
# operators. It takes as input a DataFrame of metric values of operators of an experiment 
# (e.g. phases), desired metric for which the degradation is to be computed and an evaluator's
# instance. The metric values DataFrame is expected to have the following columns:
#   operator_id: unique identifier for the operator (e.g. phase)
#   metric_name: name of the metric (e.g. latency)
#   and metric_value: value of the metric
class DegradationAnalysisHelper:
    def __init__(self, metric_values: pd.DataFrame, evaluator: DegradationEvaluatorBase):
        self.metric_values = metric_values
        self.evaluator = evaluator

    # Evaluates the degradation of the provided metric name for the input ordered-list of 
    # operators ids. It filters the values from the intial DataFrame based on metric name
    # and operators, orders them baed on ordered list of operators and computes the 
    # degradation using the initialized evaluator.
    def evaluate(self, metric: str, operators: List[str]) -> float:
        # Filter the metric values for the desired metric and operators
        metric_values = self.metric_values[self.metric_values['metric_name'] == metric]
        metric_values = metric_values[metric_values['operator_id'].isin(operators)]
        metric_values['operator_index'] = metric_values['operator_id'].apply(lambda x: operators.index(x))
        metric_values = metric_values.sort_values(by='operator_index')
        metric_values = metric_values['metric_value'].tolist()
        print(metric_values)

        # Evaluate the degradation
        return self.evaluator.evaluate(metric_values)