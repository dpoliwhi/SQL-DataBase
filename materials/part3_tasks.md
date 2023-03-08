
##### 1) Write a function that returns the TransferredPoints table in a more human-readable form
Peer's nickname 1, Peer's nickname 2, number of transferred peer points. \
The number is negative if peer 2 received more points from peer 1.

Output example:

| Peer1 | Peer2 | PointsAmount |
|------|------|----|
| Aboba | Amogus | 5  |
| Amogus | Sus  | -2 |
| Sus  | Aboba | 0  |

##### 2) Write a function that returns a table of the following form: user name, name of the checked task, number of XP received
Include in the table only tasks that have successfully passed the check (according to the Checks table). \
One task can be completed successfully several times. In this case, include all successful checks in the table.

Output example:

| Peer   | Task | XP  |
|--------|------|-----|
| Aboba  | C8   | 800 |
| Aboba  | CPP3 | 750 |
| Amogus | DO5  | 175 |
| Sus    | A4   | 325 |

##### 3) Write a function that finds the peers who have not left campus for the whole day
Function parameters: day, for example 12.05.2022. \
The function returns only a list of peers.

##### 4) Find the percentage of successful and unsuccessful checks for all time
Output format: percentage of successful checks, percentage of unsuccessful ones

Output example:
| SuccessfulChecks | UnsuccessfulChecks |
|------------------|--------------------|
| 35               | 65                 |

##### 5) Calculate the change in the number of peer points of each peer using the TransferredPoints table
Output the result sorted by the change in the number of points. \
Output format: peer's nickname, change in the number of peer points

Output example:
| Peer   | PointsChange |
|--------|--------------|
| Aboba  | 8            |
| Amogus | 1            |
| Sus    | -3           |

##### 6) Calculate the change in the number of peer points of each peer using the table returned by [the first function from Part 3](#1-write-a-function-that-returns-the-transferredpoints-table-in-a-more-human-readable-form)
Output the result sorted by the change in the number of points. \
Output format: peer's nickname, change in the number of peer points

Output example:
| Peer   | PointsChange |
|--------|--------------|
| Aboba  | 8            |
| Amogus | 1            |
| Sus    | -3           |

##### 7) Find the most frequently checked task for each day
If there is the same number of checks for some tasks in a certain day, output all of them. \
Output format: day, task name

Output example:
| Day        | Task |
|------------|------|
| 12.05.2022 | A1   |
| 17.04.2022 | CPP3 |
| 23.12.2021 | C5   |

##### 8) Determine the duration of the last P2P check
Duration means the difference between the time specified in the record with the status "start" and the time specified in the record with the status "success" or "failure". \
Output format: check duration

##### 9) Find all peers who have completed the whole given block of tasks and the completion date of the last task
Procedure parameters: name of the block, for example “CPP”. \
The result is sorted by the date of completion. \
Output format: peer's name, date of completion of the block (i.e. the last completed task from that block)

Output example:
| Peer   | Day        |
|--------|------------|
| Aboba  | 12.05.2022 |
| Amogus | 17.05.2022 |
| Sus    | 23.06.2022 |

##### 10) Determine which peer each student should go to for a check.
You should determine it according to the recommendations of the peer's friends, i.e. you need to find the peer with the greatest number of friends who recommend to be checked by him. \
Output format: peer's nickname, nickname of the checker found

Output example:
| Peer   | RecommendedPeer  |
|--------|-----------------|
| Aboba  | Sus             |
| Amogus | Aboba           |
| Sus    | Aboba           |

##### 11) Determine the percentage of peers who:
- Started block 1
- Started block 2
- Started both
- Have not started any of them

Procedure parameters: name of block 1, for example CPP, name of block 2, for example A. \
Output format: percentage of those who started the first block, percentage of those who started the second block, percentage of those who started both blocks, percentage of those who did not started any of them

Output example:
| StartedBlock1 | StartedBlock2 | StartedBothBlocks | DidntStartAnyBlock |
|---------------|---------------|-------------------|--------------------|
| 20            | 20            | 5                 | 55                 |

##### 12) Determine *N* peers with the greatest number of friends
Parameters of the procedure: the *N* number of peers . \
The result is sorted by the number of friends. \
Output format: peer's name, number of friends

Output example:
| Peer   | FriendsCount |
|--------|-------------|
| Aboba  | 8           |
| Amogus | 15          |
| Sus    | 0           |

##### 13) Determine the percentage of peers who have ever successfully passed a check on their birthday
Also determine the percentage of peers who have ever failed a check on their birthday. \
Output format: percentage of successes on birthday, percentage of failures on birthday

Output example:
| SuccessfulChecks | UnsuccessfulChecks |
|------------------|--------------------|
| 60               | 40                 |

##### 14) Determine the total amount of XP gained by each peer
If one task is performed more than once, the amount of XP received for it equals its maximum amount for that task. \
Output the result sorted by number of XP. \
Output format: peer's name, the number of XP

Output example:
| Peer   | XP    |
|--------|-------|
| Aboba  | 8000  |
| Amogus | 15000 |
| Sus    | 400   |

##### 15) Determine all peers who did the given tasks 1 and 2, but did not do task 3
Procedure parameters: names of tasks 1, 2 and 3. \
Output format: list of peers

##### 16) Using recursive common table expression, output the number of preceding tasks for each task
I. e. How many tasks have to be done, based on entry conditions, to get access to the current one. \
Output format: task name, number of preceding tasks

Output example:
| Task | PrevCount |
|------|-----------|
| CPP3 | 7         |
| A1   | 9         |
| C5   | 1         |

##### 17) Find "lucky" days for checks. A day is considered "lucky" if it has at least *N* consecutive successful checks
Parameters of the procedure: the *N* number of consecutive successful checks . \
The time of the check is the start time of the P2P step. \
Successful consecutive checks are the checks with no unsuccessful checks in between. \
The amount of XP for each of these checks must be at least 80% of the maximum. \
Output format: list of days

##### 18) Determine the peer with the greatest number of completed tasks
Output format: peer's nickname, number of completed tasks

Output example:
| Peer   | XP    |
|--------|-------|
| Amogus | 5 |

##### 19) Find the peer with the highest amount of XP
Output format: peer's nickname, amount of XP

Output example:
| Peer   | XP    |
|--------|-------|
| Amogus | 15000 |

##### 20) Find the peer who spent the longest amount of time on campus today
Output format: peer's nickname

##### 21) Determine the peers that came before the given time at least *N* times during the whole time
Procedure parameters: time, *N* number of times . \
Output format: list of peers

##### 22) Determine the peers who left the campus more than *M* times during the last *N* days
Procedure parameters: *N* number of days , *M* number of times . \
Output format: list of peers

##### 23) Determine which peer was the last to come in today
Output format: peer's nickname

##### 24) Determine the peer that left campus yesterday for more than *N* minutes
Parameters of the procedure: number of minutes *N*. \
Output format: list of peers

##### 25) Determine for each month the percentage of early entries
For each month, count how many times people born in that month came to campus during the whole time (we'll call this the total number of entries). \
For each month, count the number of times people born in that month have come to campus before 12:00 in all time (we'll call this the number of early entries). \
For each month, count the percentage of early entries to campus relative to the total number of entries. \
Output format: month, percentage of early entries

Output example:

| Month    | EarlyEntries |
|----------|--------------|
| January  | 15           |
| February | 35           |
| March    | 45           |
