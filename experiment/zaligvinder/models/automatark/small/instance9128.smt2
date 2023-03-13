(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3AlogUser-Agent\x3AonSubject\x3A
(assert (not (str.in_re X (str.to_re "Host:logUser-Agent:onSubject:\u{0a}"))))
; Host\x3ATest\x3C\x2Fchat\x3EResultsSubject\x3A
(assert (str.in_re X (str.to_re "Host:Test</chat>ResultsSubject:\u{0a}")))
; ((\d{1,5})*\.*(\d{0,3})"[W|D|H|DIA][X|\s]).*
(assert (not (str.in_re X (re.++ (re.* re.allchar) (str.to_re "\u{0a}") (re.* ((_ re.loop 1 5) (re.range "0" "9"))) (re.* (str.to_re ".")) ((_ re.loop 0 3) (re.range "0" "9")) (str.to_re "\u{22}") (re.union (str.to_re "W") (str.to_re "|") (str.to_re "D") (str.to_re "H") (str.to_re "I") (str.to_re "A")) (re.union (str.to_re "X") (str.to_re "|") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))))
; /filename=[^\n]*\u{2e}plf/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".plf/i\u{0a}"))))
; ^((([sS]|[nN])[a-hA-Hj-zJ-Z])|(([tT]|[oO])[abfglmqrvwABFGLMQRVW])|([hH][l-zL-Z])|([jJ][lmqrvwLMQRVW]))([0-9]{2})?([0-9]{2})?([0-9]{2})?([0-9]{2})?([0-9]{2})?$
(assert (str.in_re X (re.++ (re.union (re.++ (re.union (str.to_re "s") (str.to_re "S") (str.to_re "n") (str.to_re "N")) (re.union (re.range "a" "h") (re.range "A" "H") (re.range "j" "z") (re.range "J" "Z"))) (re.++ (re.union (str.to_re "t") (str.to_re "T") (str.to_re "o") (str.to_re "O")) (re.union (str.to_re "a") (str.to_re "b") (str.to_re "f") (str.to_re "g") (str.to_re "l") (str.to_re "m") (str.to_re "q") (str.to_re "r") (str.to_re "v") (str.to_re "w") (str.to_re "A") (str.to_re "B") (str.to_re "F") (str.to_re "G") (str.to_re "L") (str.to_re "M") (str.to_re "Q") (str.to_re "R") (str.to_re "V") (str.to_re "W"))) (re.++ (re.union (str.to_re "h") (str.to_re "H")) (re.union (re.range "l" "z") (re.range "L" "Z"))) (re.++ (re.union (str.to_re "j") (str.to_re "J")) (re.union (str.to_re "l") (str.to_re "m") (str.to_re "q") (str.to_re "r") (str.to_re "v") (str.to_re "w") (str.to_re "L") (str.to_re "M") (str.to_re "Q") (str.to_re "R") (str.to_re "V") (str.to_re "W")))) (re.opt ((_ re.loop 2 2) (re.range "0" "9"))) (re.opt ((_ re.loop 2 2) (re.range "0" "9"))) (re.opt ((_ re.loop 2 2) (re.range "0" "9"))) (re.opt ((_ re.loop 2 2) (re.range "0" "9"))) (re.opt ((_ re.loop 2 2) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
(check-sat)
