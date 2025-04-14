// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IERC20{
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint amount) external returns(bool);
    function balanceOf(address account) external view returns (uint256);
}

contract Loan {
    address public borrower;
    address public lender;
    uint256 public principalAmount;
    uint256 public interestRate;
    uint256 public loanDuration;
    uint256 public startTime;
    uint256 public totalRepaid;
    IERC20 public loanToken;


    enum LoanState { CREATED, FUNDED, ACTIVE, REPAID, DEFAULTED }
    LoanState public state;

    event LoanCreated(address indexed borrower);
    event LoanFunded(address indexed lender);
    event PaymentReceived(address indexed from, uint256 amount);
    event LoanRepaid();
    event LoanDefaulted();

    constructor(
        address _borrower,
        uint256 _principalAmount,
        uint256 _interestRate,
        uint256 _loanDuration,
        address _loanToken
    ) {
        require(_borrower != address(0), "Borrower cannot be zero address");
        require(_principalAmount > 0, "Principal must be greater than zero");
        require(_loanToken != address(0), "Token address cannot be zero");

        borrower = _borrower;
        principalAmount=_principalAmount;
        interestRate = _interestRate;
        loanDuration = _loanDuration;
        loanToken = IERC20(_loanToken);
        state=LoanState.CREATED;

        emit LoanCreated(_borrower);
    }

    function fundLoan() external {
        require(state == LoanState.CREATED, "Loan already funded");
        require(msg.sender != borrower, "Borrower cannot fund their own loan");

        lender = msg.sender;
        require(
            loanToken.transferFrom(lender, address(this), principalAmount),
            "Token transfer failed"
        );

        startTime = block.timestamp;
        state = LoanState.FUNDED;

        emit LoanFunded(lender);
    }

    function activeLoan() external {
        require(state == LoanState.FUNDED, "Loan must be funded to activate active");
        require(msg.sender == borrower, "Only borrower can activate");
        state = LoanState.ACTIVE;
    }

    function repay(uint256 amount) external {
        require(state == LoanState.ACTIVE, "Loan not active");
        require(msg.sender == borrower, "Only borrower can repay");

        uint totalDue = getTotalDue();
        require(amount > 0 && amount <= (totalDue - totalRepaid), "Invalid repayment amount");
        require(
            loanToken.transferFrom(borrower, lender, amount),
            "Repayment transfer failed"
        );

        totalRepaid += amount;

        emit PaymentReceived(borrower, amount);

        if (totalRepaid >= totalDue) {
            state = LoanState.REPAID;
            emit LoanRepaid();

        }
    }

    function getTotalDue() public view returns (uint256) {
        if (state != LoanState.ACTIVE) return 0;
        uint256 elapsedTime = block.timestamp - startTime;
        uint256 interest = (principalAmount * interestRate * elapsedTime) / (365 days * 1000);
        return principalAmount + interest;
    }

    function checkForDefault() external {
        if (state == LoanState.ACTIVE && block.timestamp > startTime + loanDuration){

        state = LoanState.DEFAULTED;
        emit LoanDefaulted();
        }
    }

    function getRemainingBalance() external view returns (uint256) {
        uint256 totalDue = getTotalDue();
        return totalDue > totalRepaid ? totalDue-totalRepaid : 0;

    }
 
}