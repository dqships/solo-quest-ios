//
//  QuizData.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import Foundation

enum QuizData {
    static let questions: [QuizQuestion] = [
        QuizQuestion(
            key: "quiz.luck.shop",
            defaultText: "You're walking in a new neighborhood. You see an interesting shop you've never noticed. Do you go in?",
            options: [
                QuizOption(key: "quiz.opt.always", defaultText: "Always", score: 750),
                QuizOption(key: "quiz.opt.sometimes", defaultText: "Sometimes", score: 400),
                QuizOption(key: "quiz.opt.rarely", defaultText: "Rarely", score: 175),
                QuizOption(key: "quiz.opt.never", defaultText: "Never", score: 0)
            ],
            primaryStat: "luck"
        ),
        QuizQuestion(
            key: "quiz.luck.invite",
            defaultText: "A friend invites you to an event you know nothing about. Your response?",
            options: [
                QuizOption(key: "quiz.opt.yes_fun", defaultText: "Yes, sounds fun!", score: 750),
                QuizOption(key: "quiz.opt.maybe_more", defaultText: "Maybe, tell me more", score: 400),
                QuizOption(key: "quiz.opt.probably_not", defaultText: "Probably not", score: 175)
            ],
            primaryStat: "luck"
        ),
        QuizQuestion(
            key: "quiz.charisma.elevator",
            defaultText: "You're in an elevator with a stranger. The ride is 10 floors. Do you start a conversation?",
            options: [
                QuizOption(key: "quiz.opt.usually", defaultText: "Usually", score: 750),
                QuizOption(key: "quiz.opt.sometimes", defaultText: "Sometimes", score: 400),
                QuizOption(key: "quiz.opt.rarely", defaultText: "Rarely", score: 175),
                QuizOption(key: "quiz.opt.never", defaultText: "Never", score: 0)
            ],
            primaryStat: "charisma"
        ),
        QuizQuestion(
            key: "quiz.charisma.favor",
            defaultText: "You need to ask a favor from someone you barely know. How do you approach it?",
            options: [
                QuizOption(key: "quiz.opt.directly", defaultText: "Directly and confidently", score: 750),
                QuizOption(key: "quiz.opt.nervously", defaultText: "Nervously but I do it", score: 400),
                QuizOption(key: "quiz.opt.avoid", defaultText: "I avoid it or ask someone else", score: 175)
            ],
            primaryStat: "charisma"
        ),
        QuizQuestion(
            key: "quiz.charisma.gathering",
            defaultText: "At a social gathering, you're more likely to...",
            options: [
                QuizOption(key: "quiz.opt.talk_new", defaultText: "Talk to new people", score: 750),
                QuizOption(key: "quiz.opt.stick_friends", defaultText: "Stick with friends", score: 400),
                QuizOption(key: "quiz.opt.keep_self", defaultText: "Keep to yourself", score: 175)
            ],
            primaryStat: "charisma"
        ),
        QuizQuestion(
            key: "quiz.strength.stairs",
            defaultText: "When you see stairs vs. an elevator, you usually...",
            options: [
                QuizOption(key: "quiz.opt.take_stairs", defaultText: "Take the stairs", score: 750),
                QuizOption(key: "quiz.opt.depends_floors", defaultText: "Depends on how many floors", score: 400),
                QuizOption(key: "quiz.opt.take_elevator", defaultText: "Take the elevator", score: 175)
            ],
            primaryStat: "strength"
        ),
        QuizQuestion(
            key: "quiz.strength.furniture",
            defaultText: "Someone asks you to help move furniture. Your first thought?",
            options: [
                QuizOption(key: "quiz.opt.sure", defaultText: "Sure, let's do it", score: 750),
                QuizOption(key: "quiz.opt.okay_breaks", defaultText: "Okay, but I might need breaks", score: 400),
                QuizOption(key: "quiz.opt.excuse", defaultText: "I'll find an excuse", score: 175)
            ],
            primaryStat: "strength"
        ),
        QuizQuestion(
            key: "quiz.stamina.project",
            defaultText: "You start a project that's more work than expected. You...",
            options: [
                QuizOption(key: "quiz.opt.push_through", defaultText: "Push through to finish", score: 750),
                QuizOption(key: "quiz.opt.breaks_complete", defaultText: "Take breaks but complete it", score: 400),
                QuizOption(key: "quiz.opt.give_up", defaultText: "Give up or significantly reduce scope", score: 175)
            ],
            primaryStat: "stamina"
        ),
        QuizQuestion(
            key: "quiz.stamina.tedious",
            defaultText: "How do you handle long, tedious tasks?",
            options: [
                QuizOption(key: "quiz.opt.power_through", defaultText: "Power through in one go", score: 750),
                QuizOption(key: "quiz.opt.chunks", defaultText: "Break into chunks over time", score: 400),
                QuizOption(key: "quiz.opt.procrastinate", defaultText: "Procrastinate or avoid", score: 175)
            ],
            primaryStat: "stamina"
        ),
        QuizQuestion(
            key: "quiz.resilience.fail",
            defaultText: "You try something new and fail publicly. Next time you...",
            options: [
                QuizOption(key: "quiz.opt.try_again_imm", defaultText: "Try again immediately", score: 750),
                QuizOption(key: "quiz.opt.try_again_later", defaultText: "Try again after some time", score: 400),
                QuizOption(key: "quiz.opt.avoid_situation", defaultText: "Avoid that situation", score: 175)
            ],
            primaryStat: "resilience"
        ),
        QuizQuestion(
            key: "quiz.resilience.rejection",
            defaultText: "When facing rejection or criticism, you typically...",
            options: [
                QuizOption(key: "quiz.opt.motivation", defaultText: "Use it as motivation", score: 750),
                QuizOption(key: "quiz.opt.recover", defaultText: "Feel down but recover", score: 400),
                QuizOption(key: "quiz.opt.personal", defaultText: "Take it very personally", score: 175)
            ],
            primaryStat: "resilience"
        ),
        QuizQuestion(
            key: "quiz.resilience.goal",
            defaultText: "You set a goal and miss it. Your response?",
            options: [
                QuizOption(key: "quiz.opt.adjust", defaultText: "Adjust and try again", score: 750),
                QuizOption(key: "quiz.opt.discouraged", defaultText: "Feel discouraged but eventually continue", score: 400),
                QuizOption(key: "quiz.opt.give_up_goal", defaultText: "Give up on that goal", score: 175)
            ],
            primaryStat: "resilience"
        ),
        QuizQuestion(
            key: "quiz.intelligence.unknown",
            defaultText: "When you encounter something you don't understand, you...",
            options: [
                QuizOption(key: "quiz.opt.research", defaultText: "Research it immediately", score: 750),
                QuizOption(key: "quiz.opt.lookup_later", defaultText: "Look it up when convenient", score: 400),
                QuizOption(key: "quiz.opt.move_on", defaultText: "Move on", score: 175)
            ],
            primaryStat: "intelligence"
        ),
        QuizQuestion(
            key: "quiz.intelligence.conversation",
            defaultText: "After a difficult conversation or event, you...",
            options: [
                QuizOption(key: "quiz.opt.reflect", defaultText: "Reflect on what happened and what you learned", score: 750),
                QuizOption(key: "quiz.opt.think_briefly", defaultText: "Think about it briefly", score: 400),
                QuizOption(key: "quiz.opt.forget", defaultText: "Try to forget about it", score: 175)
            ],
            primaryStat: "intelligence"
        ),
        QuizQuestion(
            key: "quiz.intelligence.skill",
            defaultText: "You're learning a new skill. Your approach?",
            options: [
                QuizOption(key: "quiz.opt.fundamentals", defaultText: "Study the fundamentals first", score: 750),
                QuizOption(key: "quiz.opt.learn_doing", defaultText: "Learn by doing", score: 400),
                QuizOption(key: "quiz.opt.wing_it", defaultText: "Wing it", score: 175)
            ],
            primaryStat: "intelligence"
        )
    ]
}
