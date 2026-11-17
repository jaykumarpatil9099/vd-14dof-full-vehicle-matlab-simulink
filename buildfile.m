function plan = buildfile
%BUILDFILE  MATLAB build plan (R2023b+ build tool; model saved in R2024b).
%   buildtool   -> static code analysis + tests (parameters sane, model loads)
import matlab.buildtool.tasks.CodeIssuesTask
import matlab.buildtool.tasks.TestTask

plan = buildplan(localfunctions);

plan("check") = CodeIssuesTask(["02_data", "tests"]);
plan("test")  = TestTask("tests");

plan.DefaultTasks = ["check", "test"];
end
