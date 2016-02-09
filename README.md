# DistributedTestFramework
This is a test framework for doing automated testing on distributed application.

This test framework is for testing a distributed application. For example, an application whisch has several components distributed over different hosts. During execution of the job or workflow, the application interactions with different components on different hosts, and generates the desired result. So there would be diffewrent logs distributed on different hosts. We need to verify all these logs along with the workflow. And alsof for security purpose, you are not allowed to keep external scripts on these hosts for testing. In that case you can put this framework in a host, from which all the setup is accessible over ssh and execute the test scripts.


This is just an example of testcases, you can include any number of test cases in this framework as per your requirement.
Any kind of scripting languages can be used here.
