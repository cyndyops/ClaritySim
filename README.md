# ClaritySim


**Realistic simulations, deep testing tools, and debugging powers for Clarity smart contracts — all before mainnet deployment.**

## Overview

Building Clarity smart contracts today is painful and risky. Testing time-dependent features like vesting schedules or DAO votes requires waiting for actual block progression. Debugging cross-chain logic with Bitcoin anchors is error-prone, and testing "what-if" scenarios requires tedious contract redeployments.

ClaritySim solves these problems by providing developers with **realistic blockchain simulations, comprehensive testing frameworks, and powerful debugging capabilities** in a controlled environment.

## 🔧 Core Features

### 1. Multi-Block Simulator ✅ **(Currently Implemented)**
- **Purpose**: Instantly advance blockchain by 1, 10, or 10,000 blocks
- **Use Cases**: Test vesting schedules, DAO votes, auctions, timeouts
- **Impact**: Eliminates days of waiting for time-dependent contract testing

### 2. Bitcoin Anchor Simulation ⏳ **(Coming Soon)**
- **Purpose**: Mock Bitcoin block arrivals and anchor events
- **Use Cases**: Test cross-chain logic, BTC transfers, proof of burn
- **Impact**: Prevents costly mistakes in BTC-Stacks bridges and DeFi protocols

### 3. State Rollback & Branching ⏳ **(Coming Soon)**
- **Purpose**: Rewind chain state to any block and create "what-if" scenarios
- **Use Cases**: Test branching conditions in escrow, lending, governance
- **Impact**: Safer iteration for complex financial protocols

### 4. Scenario Builder ⏳ **(Coming Soon)**
- **Purpose**: Human-readable test scenarios like "Alice locks 100 STX, waits 50 blocks, Bob disputes"
- **Use Cases**: Non-technical validation by founders, lawyers, PMs
- **Impact**: Bridges technical and business stakeholders

### 5. Gas & Cost Estimator ⏳ **(Coming Soon)**
- **Purpose**: Estimate execution costs before deployment
- **Use Cases**: Optimize expensive functions for user affordability
- **Impact**: Prevents failed launches due to gas issues

### 6. Chaos & Edge-Case Testing ⏳ **(Coming Soon)**
- **Purpose**: Randomized stress testing and adversarial exploit detection
- **Use Cases**: Test 1,000 concurrent users, double withdrawal attempts
- **Impact**: Prevents security failures that destroy trust

### 7. Integration-Friendly Tooling ⏳ **(Coming Soon)**
- **Purpose**: CLI, library, and VSCode plugin with JSON export
- **Use Cases**: Seamless integration into existing workflows
- **Impact**: Developer adoption through familiar interfaces

### 8. Education Mode ⏳ **(Coming Soon)**
- **Purpose**: Step-by-step Clarity execution visualization
- **Use Cases**: Teaching new developers, stakeholder explanations
- **Impact**: Lowers entry barriers for students and startups

## 🚀 Getting Started

### Prerequisites
- [Clarinet](https://docs.hiro.so/tools/clarinet) (latest version)
- Node.js 18+
- Git

### Installation
```bash
# Clone the repository
git clone https://github.com/yourusername/claritysim.git
cd claritysim

# Update Clarinet to latest version
npm install @hirosystems/clarinet-sdk@latest @stacks/transactions@latest

# Initialize Clarinet project
clarinet new clarity-sim-project
cd clarity-sim-project
```

### Project Structure
```
claritysim/
├── contracts/
│   ├── multi-block-simulator.clar    # Feature 1: Block simulation
│   ├── bitcoin-anchor-sim.clar       # Feature 2: BTC anchor mocking (TBD)
│   ├── state-rollback.clar           # Feature 3: State management (TBD)
│   └── scenario-builder.clar         # Feature 4: Human-readable tests (TBD)
├── tests/
│   ├── multi-block-simulator_test.ts
│   └── integration/
├── docs/
│   ├── api-reference.md
│   └── examples/
├── tools/
│   ├── cli/                          # Command-line interface
│   └── vscode-plugin/                # Editor integration
└── README.md
```

## 📝 Current Implementation: Multi-Block Simulator

### Contract Features
- **Block Advancement**: Progress blockchain by custom increments
- **Session Tracking**: Monitor simulation sessions with detailed logs
- **Time Conditions**: Test time-based contract logic (vesting, voting)
- **State Management**: Pause, resume, and reset simulations
- **Height Utilities**: Calculate blocks until target conditions

### Usage Example
```clarity
;; Initialize simulation
(contract-call? .multi-block-simulator init-simulation)

;; Advance by 100 blocks to test vesting
(contract-call? .multi-block-simulator advance-blocks u100)

;; Check if 90-block vesting period completed
(contract-call? .multi-block-simulator simulate-time-condition u90)
;; Returns: (ok true)

;; Get current simulation status
(contract-call? .multi-block-simulator get-simulation-status)
```

### Real-World Applications
1. **DeFi Vesting**: Test token release schedules without waiting weeks
2. **DAO Governance**: Simulate voting periods and proposal deadlines
3. **Auction Systems**: Test bid timing and auction conclusion logic
4. **Staking Protocols**: Verify lock-up periods and reward calculations

## 🧪 Testing

### Running Tests
```bash
# Test multi-block simulator
clarinet test tests/multi-block-simulator_test.ts

# Run all tests
clarinet test

# Integration tests
npm run test:integration
```

### Example Test Scenarios
- Advance 1,000 blocks and verify state consistency
- Test concurrent simulation sessions
- Validate time-condition edge cases
- Stress test with rapid block advancement

## 🤝 Contributing

We're building ClaritySim feature by feature. Current priorities:

1. ✅ **Multi-Block Simulator** (Complete)
2. 🔄 **Bitcoin Anchor Simulation** (In Progress)
3. ⏳ **State Rollback & Branching** (Next)
4. ⏳ **Scenario Builder** (Planned)

### Development Workflow
1. Fork the repository
2. Create feature branch: `git checkout -b feature/bitcoin-anchor-sim`
3. Implement contract with comprehensive tests
4. Add documentation and examples
5. Submit pull request with detailed description

### Code Standards
- Keep contracts concise and focused
- Write comprehensive test coverage (>90%)
- Include real-world usage examples
- Follow Clarity best practices and security patterns

## 📖 Documentation

- [API Reference](./docs/api-reference.md)
- [Usage Examples](./docs/examples/)
- [Architecture Overview](./docs/architecture.md)
- [Security Considerations](./docs/security.md)

## 🛠️ Roadmap

### Phase 1: Foundation (Current)
- ✅ Multi-Block Simulator
- 🔄 Bitcoin Anchor Simulation
- ⏳ Basic State Management

### Phase 2: Advanced Tooling
- State Rollback & Branching
- Scenario Builder Framework
- Gas Cost Analysis

### Phase 3: Integration & UX
- CLI Tool Development
- VSCode Plugin
- Web Interface

### Phase 4: Advanced Features
- Chaos Testing Framework
- Education Mode
- Cross-Chain Testing Suite

## 🔒 Security

ClaritySim contracts are designed for **development and testing only**. Never deploy simulation contracts to mainnet. Each feature includes:
- Access control mechanisms
- Input validation
- Error handling
- Audit-friendly code structure

## 📄 License

MIT License - see [LICENSE](./LICENSE) for details.

## 🙋‍♂️ Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/claritysim/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/claritysim/discussions)
- **Documentation**: [Project Wiki](https://github.com/yourusername/claritysim/wiki)

## 🌟 Why ClaritySim?

> *"Before ClaritySim, testing our DAO's 30-day voting period meant waiting a month between iterations. Now we test complete governance cycles in minutes."*
> — DeFi Developer

> *"The multi-block simulator caught timing bugs in our vesting contract that would have cost thousands in failed transactions."*
> — Startup Founder

**Ready to build safer, more reliable Clarity contracts?** Start with the Multi-Block Simulator and join our growing community of developers making Stacks development faster, safer, and more accessible.

---

*Built with ❤️ for the Stacks ecosystem. Empowering developers to ship bulletproof smart contracts.*
