classdef Dof14Test < matlab.unittest.TestCase
    %DOF14TEST  Smoke + sanity tests for the 14-DoF model.
    %   Run with:  buildtool test

    properties
        Root
        P   % parameter struct
    end

    methods (TestClassSetup)
        function readParameters(tc)
            tc.Root = fileparts(fileparts(mfilename("fullpath")));
            tc.P = loadParameters(fullfile(tc.Root, "02_data", "parameters", ...
                "Complete_vehicle_simulation_dof14_model_parameters.m"));
        end
    end

    methods (Test)
        function parametersDefineTyreSets(tc)
            for name = ["Bf", "Cf", "Ef", "Br", "Cr", "Er", "a1f", "a2f", "a1r", "a2r"]
                tc.verifyTrue(isfield(tc.P, name), "Missing parameter " + name);
            end
        end

        function brakeBalanceIsAFraction(tc)
            tc.assumeTrue(isfield(tc.P, "balance"));
            tc.verifyGreaterThan(tc.P.balance, 0);
            tc.verifyLessThan(tc.P.balance, 1);
        end

        function physicalParametersArePositive(tc)
            for name = ["m", "ms", "L", "tf", "tr", "a", "b", "r"]
                if isfield(tc.P, name)
                    tc.verifyGreaterThan(tc.P.(name), 0, name + " must be positive");
                end
            end
        end

        function axleDistancesSumToWheelbase(tc)
            tc.assumeTrue(all(isfield(tc.P, {'a', 'b', 'L'})));
            tc.verifyEqual(tc.P.a + tc.P.b, tc.P.L, "RelTol", 1e-6);
        end

        function modelLoads(tc)
            f = fullfile(tc.Root, "03_model", "Complete_vehicle_simulation_dof14_model.slx");
            load_system(f);
            tc.addTeardown(@() close_system("Complete_vehicle_simulation_dof14_model", 0));
            tc.verifyTrue(bdIsLoaded("Complete_vehicle_simulation_dof14_model"));
        end
    end
end

function P = loadParameters(paramFile)
% Run the parameter script in an isolated workspace and return its variables as a struct
run(paramFile);
clear paramFile
matFile = [tempname '.mat'];
save(matFile);
P = rmfield(load(matFile), "matFile");
delete(matFile);
end
