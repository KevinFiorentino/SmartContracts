// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract FundProject {

    struct Funding{
        uint goal;
        uint totalFunded;
        bool isFundable;
        address payable owner;
    }

    Funding public fund;

    constructor() {
        fund = Funding(0, 0, true, payable(msg.sender));            // 1 ETH = 1^18 = 1000000000000000000
    }

    /* ********** EVENTS ********** */

    event NotifyFund(
        address funder,
        uint amount
    );

    event NotifyStatusChange(
        bool newStatus
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


    /* ********** FUNCTIONS ********** */

    function setGoal(uint g) public onlyOwner {
        fund.goal = g;
    }

    function viewGoal() public view hasGoal returns(uint256) {
        return fund.goal;
    }

    function viewRemaining() public view hasGoal returns(uint256) {
        return fund.goal - fund.totalFunded;
    }

    function changeStatusProject() public onlyOwner {
        fund.isFundable = !fund.isFundable;
        emit NotifyStatusChange(fund.isFundable);
    }

    function addFounds() public hasGoal notIsOwner payable {
        if (fund.isFundable == false)
            revert projectAvailable("The project is closed.");

        fund.owner.transfer(msg.value);
        fund.totalFunded += msg.value;
        emit NotifyFund(msg.sender, msg.value);

        // Close project automatically
        if (fund.totalFunded >= fund.goal)
            fund.isFundable = false;
    }

}
