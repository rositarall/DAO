// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleGovernance {
    struct Proposal {
        uint256 id;
        address proposer;
        string description;
        uint256 voteCount;
        bool executed;
        mapping(address => bool) voted;
    }

    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;

    mapping(address => uint256) public balances;
    uint256 public totalSupply;

    event ProposalCreated(uint256 id, address proposer, string description);
    event Voted(uint256 proposalId, address voter);
    event Executed(uint256 proposalId);

    constructor() {
        // Начальное распределение токенов
        balances[msg.sender] = 1000;
        totalSupply = 1000;
    }

    modifier onlyTokenHolders() {
        require(balances[msg.sender] > 0, "Вы не являетесь держателем токенов");
        _;
    }

    function createProposal(string memory _description) public onlyTokenHolders {
        proposalCount++;
        Proposal storage newProposal = proposals[proposalCount];
        newProposal.id = proposalCount;
        newProposal.proposer = msg.sender;
        newProposal.description = _description;

        emit ProposalCreated(proposalCount, msg.sender, _description);
    }

    function vote(uint256 _proposalId) public onlyTokenHolders {
        Proposal storage proposal = proposals[_proposalId];
        require(!proposal.voted[msg.sender], "Вы уже проголосовали");
        require(!proposal.executed, "Предложение уже исполнено");

        proposal.voted[msg.sender] = true;
        proposal.voteCount += balances[msg.sender];

        emit Voted(_proposalId, msg.sender);
    }

    function executeProposal(uint256 _proposalId) public {
        Proposal storage proposal = proposals[_proposalId];
        require(!proposal.executed, "Предложение уже исполнено");
        require(proposal.voteCount > totalSupply / 2, "Недостаточно голосов для исполнения");

        proposal.executed = true;

        // Здесь можно добавить логику исполнения предложения

        emit Executed(_proposalId);
    }

    // Дополнительные функции для управления токенами могут быть добавлены здесь
}
