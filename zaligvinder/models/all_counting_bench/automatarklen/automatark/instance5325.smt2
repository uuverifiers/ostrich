(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}jpm/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".jpm/i\u{0a}"))))
; ^(\d*\s*\-?\s*\d*)$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.* (re.range "0" "9")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "-")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.range "0" "9"))))))
; /^\d+$/P
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.+ (re.range "0" "9")) (str.to_re "/P\u{0a}")))))
; ^([\!#\$%&'\*\+/\=?\^`\{\|\}~a-zA-Z0-9_-]+[\.]?)+[\!#\$%&'\*\+/\=?\^`\{\|\}~a-zA-Z0-9_-]+@{1}((([0-9A-Za-z_-]+)([\.]{1}[0-9A-Za-z_-]+)*\.{1}([A-Za-z]){1,6})|(([0-9]{1,3}[\.]{1}){3}([0-9]{1,3}){1}))$
(assert (not (str.in_re X (re.++ (re.+ (re.++ (re.+ (re.union (str.to_re "!") (str.to_re "#") (str.to_re "$") (str.to_re "%") (str.to_re "&") (str.to_re "'") (str.to_re "*") (str.to_re "+") (str.to_re "/") (str.to_re "=") (str.to_re "?") (str.to_re "^") (str.to_re "`") (str.to_re "{") (str.to_re "|") (str.to_re "}") (str.to_re "~") (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-"))) (re.opt (str.to_re ".")))) (re.+ (re.union (str.to_re "!") (str.to_re "#") (str.to_re "$") (str.to_re "%") (str.to_re "&") (str.to_re "'") (str.to_re "*") (str.to_re "+") (str.to_re "/") (str.to_re "=") (str.to_re "?") (str.to_re "^") (str.to_re "`") (str.to_re "{") (str.to_re "|") (str.to_re "}") (str.to_re "~") (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-"))) ((_ re.loop 1 1) (str.to_re "@")) (re.union (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_") (str.to_re "-"))) (re.* (re.++ ((_ re.loop 1 1) (str.to_re ".")) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_") (str.to_re "-"))))) ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 1 6) (re.union (re.range "A" "Z") (re.range "a" "z")))) (re.++ ((_ re.loop 3 3) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re ".")))) ((_ re.loop 1 1) ((_ re.loop 1 3) (re.range "0" "9"))))) (str.to_re "\u{0a}")))))
; /\u{2e}f4p([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.f4p") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
