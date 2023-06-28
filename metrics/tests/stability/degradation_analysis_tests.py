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

import unittest
import pandas as pd
from stability import *

class DegradationEvaluatorBaseTest(unittest.TestCase):
    def setUp(self):
        self.evaluator = DegradationEvaluatorBase()

    # Test that the evaluator returns positive degradation rate
    def test_sdr_with_positive_degradation(self):
        values = [47, 75, 106, 131, 163, 157]
        expected_DR = 0.29
        degradation_rate = self.evaluator.evaluate(values)
        self.assertAlmostEqual(degradation_rate, expected_DR, delta=0.001)

    # Test that the evaluator throws an exception when the list of values is insufficient
    def test_sdr_with_insufficient_metrics(self):
        values = [47]
        #assert evaluation of values throws an exception
        with self.assertRaises(ValueError):
            self.evaluator.evaluate(values)

class DegradationAnalysisHelperTest(unittest.TestCase):
    def test_xxx(self):
        # test data
        operator_ids = ['p1', 'r1', 'p2', 'r2', 'p3']
        metric_names = ['latency', 'api']
        metric_values = [10, 1_000, 15, 1_500,
                         12, 10_000, 35, 35_000,
                         16, 100_000]

        data = []
        for operator_id in operator_ids:
            for metric_name in metric_names:
                metric_value = metric_values.pop(0)
                data.append([operator_id, metric_name, metric_value])

        df = pd.DataFrame(data, columns=['operator_id', 'metric_name', 'metric_value'])
        helper = DegradationAnalysisHelper(df, DegradationEvaluatorBase())
        
        d_r = helper.evaluate('latency', ['p1', 'p2', 'p3'])
        self.assertAlmostEqual(d_r, .266, delta=0.001)

        d_r = helper.evaluate('latency', ['p1', 'r2'])
        self.assertAlmostEqual(d_r, 2.5, delta=0.001)

        d_r = helper.evaluate('api', ['p1', 'p2', 'p3'])
        self.assertAlmostEqual(d_r, 9.0, delta=0.001)

        d_r = helper.evaluate('api', ['r1', 'r2'])
        self.assertAlmostEqual(d_r, 22.333, delta=0.001)

if __name__ == '__main__':
    unittest.main()
    