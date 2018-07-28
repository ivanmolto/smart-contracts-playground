pragma solidity ^0.4.24;

contract StateTrans {

    enum Stage {Init, Reg, Vote, Done}
    Stage public stage;
    uint startTime;
    uint public timeNow;

    constructor() {
        stage = Stage.Init;
        startTime = now;
    }

    function advanceState () public {
        timeNow = now;
        if (timeNow > (startTime + 1 minutes)) {
            startTime = now;
            if (stage == Stage.Init) {
                stage = Stage.Reg;
                return;
            }
            if (stage == Stage.Reg) {
                stage = Stage.Vote;
                return;
            }
            if (stage == Stage.Vote) {
                stage = Stage.Done;
                return;
            }
            return;
        }
    }
}
