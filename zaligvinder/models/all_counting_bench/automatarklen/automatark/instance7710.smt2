(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}wmf([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.wmf") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; <!*[^<>]*>
(assert (not (str.in_re X (re.++ (str.to_re "<") (re.* (str.to_re "!")) (re.* (re.union (str.to_re "<") (str.to_re ">"))) (str.to_re ">\u{0a}")))))
; User-Agent\x3A\x2Ftba\x2FFrom\x3A
(assert (str.in_re X (str.to_re "User-Agent:/tba/From:\u{0a}")))
; /\u{2e}vwr([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.vwr") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; ^100(\.0{0,2})? *%?$|^\d{1,2}(\.\d{1,2})? *%?$
(assert (str.in_re X (re.union (re.++ (str.to_re "100") (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (str.to_re "0")))) (re.* (str.to_re " ")) (re.opt (str.to_re "%"))) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (re.* (str.to_re " ")) (re.opt (str.to_re "%")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
