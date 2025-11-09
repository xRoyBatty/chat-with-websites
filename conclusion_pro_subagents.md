# Pro-Subagents Position

## Opening Argument


**Opening Statement: The Case for Subagents + MD Files**

The subagents + MD files architecture represents the gold standard for complex multi-agent systems, and here's why:

**1. True Parallelism & Scalability**
Unlike VPS-based approaches that rely on sequential task polling, subagents execute in parallel from the moment they're invoked. Need to analyze 10 different components simultaneously? Spawn 10 subagents instantly. No waiting for workers to poll a queue, no artificial serialization of naturally parallel work. This architecture scales horizontally without infrastructure complexity.

**2. Context Isolation & Specialized Expertise**
Each subagent receives a clean, focused context through its MD file. A database migration agent doesn't need to know about frontend styling concerns. This isolation prevents context pollution and allows each agent to operate as a true specialist with tailored instructions, reducing errors and improving output quality.

**3. Simplicity & Zero Infrastructure Overhead**
There's no VPS to maintain, no API authentication to manage, no polling mechanisms to debug, no idle timeout logic to reason about. The system is self-contained within the Claude Code environment. Deployment is instantaneous - just create an MD file and invoke a subagent. No network calls, no external dependencies, no points of failure.

**4. Built-in Coordination via Conference System**
The conference helper provides structured communication without the brittleness of shared-state task queues. Agents exchange messages explicitly, making workflows transparent and debuggable. You can see exactly what each agent is doing and why.

**5. Flexibility & Composability**
Mix and match agent capabilities on-the-fly. Create ephemeral agents for one-off tasks or persistent ones for ongoing coordination. The MD file approach makes it trivial to version, template, and reuse agent configurations.

For complex workflows requiring true parallelism, the subagents approach is unmatched in its elegance and effectiveness.


## Rebuttal


**Rebuttal: Addressing the VPS Arguments**

My opponent touts the VPS approach's "shared state" and "persistent workers," but these are solutions to problems that shouldn't exist in the first place.

**On "Shared State":** Shared mutable state is a notorious source of bugs. The VPS queue introduces race conditions, requires careful synchronization, and creates tight coupling. The subagent conference system provides message-based communication - a proven pattern that's safer and more maintainable. Shared state is a liability, not a feature.

**On "Worker Persistence":** The polling model is fundamentally wasteful. Workers sit idle burning resources while repeatedly asking "any work yet?" This is polling's classic inefficiency. Subagents use an event-driven model - they're invoked exactly when needed and complete exactly the work required. No idle waste, no artificial 10-minute timeout logic.

**On "Privacy":** Storing code on a VPS doesn't inherently improve privacy - it just moves the trust boundary. Claude Code environments already provide isolated execution. If privacy is critical, proper access controls and encryption matter more than physical location.

The VPS approach adds infrastructure complexity, network dependencies, authentication overhead, and polling inefficiency to solve coordination - a problem subagents solve natively with zero external dependencies. Occam's Razor applies: the simpler solution that achieves the same goal is superior.


## Conclusion


**Conclusion: Elegance Through Simplicity**

The debate boils down to this: do you want a system that works with the platform, or against it?

Subagents + MD files leverage Claude Code's native capabilities - parallel execution, clean contexts, instant invocation. The VPS approach fights these strengths by introducing external infrastructure, polling mechanisms, and state synchronization challenges.

For teams building real multi-agent systems, the choice is clear: subagents provide superior parallelism, zero infrastructure overhead, cleaner debugging, and more maintainable code. The VPS approach is an over-engineered solution to a problem that doesn't exist when you use the right architecture from the start.

Build with the platform, not around it.

