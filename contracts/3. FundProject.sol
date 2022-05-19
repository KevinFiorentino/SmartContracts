// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract FundProject {

    enum State { Active, Inactive }

    struct Funding {
        uint goal;
        uint totalFunded;
        State isFundable;
        address payable owner;
    }

    struct Funder {
        address funder;
        uint amount;
    }

    Funding public fund;

    Funder[] public funders;

    constructor() {
        fund = Funding(0, 0, State.Active, payable(msg.sender));            // 1 ETH = 1^18 = 1000000000000000000
    }

    /* ********** EVENTS ********** */

    event NotifyFund(
        address funder,
        uint amount
    );

    event NotifyStatusChange(
        State newStatus
    );


    /* ********** MODIFIERS & ERRORS ********** */

    modifier onlyOwner {
        require(msg.sender == fund.owner, "You need to be the owner from this contract to change the goal.");
        _;
    }

    modifier notIsOwner {
        require(msg.sender != fund.owner, "The project owner can not add founds to the project.");
        _;
    }

    modifier hasGoal() {
        require(fund.goal > 0, "The project doesn't have a goal yet.");
        _;
    }

    error projectAvailable(string msg);


    /* ********** VIEWS ********** */

    function setGoal(uint g) public onlyOwner {
        fund.goal = g;
    }

    function viewGoal() public view hasGoal returns(uint256) {
        return fund.goal;
    }

    function viewRemaining() public view hasGoal returns(uint256) {
        return fund.goal - fund.totalFunded;
    }

    function viewFunders() public view onlyOwner returns(Funder[] memory) {
        return funders;
    }


    /* ********** FUNCTIONS ********** */

    function changeStatusProject(State newState) public onlyOwner {
        fund.isFundable = newState;
        emit NotifyStatusChange(fund.isFundable);
    }

    function addFounds() public hasGoal notIsOwner payable {
        if (fund.isFundable == State.Inactive)
            revert projectAvailable("The project is closed.");

        fund.owner.transfer(msg.value);
        fund.totalFunded += msg.value;
        emit NotifyFund(msg.sender, msg.value);

        // Add founder to Array
        Funder memory f = Funder(msg.sender, msg.value);
        funders.push(f);

        // Close project automatically
        if (fund.totalFunded >= fund.goal)
            fund.isFundable = State.Inactive;
    }

}
