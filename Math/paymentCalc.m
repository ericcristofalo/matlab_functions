%% Even Out the Accounts
% Eric Cristofalo
% 2013/07/30

% Function computes a matrix of transactions necessary to even a bill of n
% number of individuals. 

% Input is a row vector of the individual prices paid.
% Example for three individuals: 
% payments = [671.12 1665.38 585.43]

function paymentCalc(payments)
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')

disp('Individual Payments Made:')
payments = payments'
numPeople = length(payments);
disp('-------------------------------------------------------------------')

total = sum(payments);
disp('Individual Amount Owed:')
indOwed = total/numPeople
disp('-------------------------------------------------------------------')
disp('Required Transactions:')
owed = indOwed-payments 
disp('Note: positive = needs to pay x amount')
disp('      negative = owed x amount')
disp('-------------------------------------------------------------------')

owedMat = zeros(numPeople,numPeople);
owedInd = find(owed<=0);
paysInd = find(owed>0);

for i = 1:length(paysInd) % for every one who owes money (rows)
    for j = 1:length(owedInd) % for every one who is owed money (cols)
        if owed(paysInd(i)) ~= 0 % as long as there is still money to be paid
            if (owed(paysInd(i))+owed(owedInd(j))) > 0 % does i cover j?
                payment = abs(owed(owedInd(j)));
                owed(owedInd(j)) = owed(owedInd(j))+payment;
                owed(paysInd(i)) = owed(paysInd(i))-payment;
            else % i doesn't cover j
                payment = owed(paysInd(i));
                owed(owedInd(j)) = owed(owedInd(j))+payment;
                owed(paysInd(i)) = owed(paysInd(i))-payment;
            end
            owedMat(paysInd(i),owedInd(j)) = payment;
        end
    end
end

disp('Final Transaction Matrix')
owedMat
disp('Read: row i owes money to column j')

disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
end