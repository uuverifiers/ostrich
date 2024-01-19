(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3A\d+dll\x3F.*started\x2EfeedbackUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.range "0" "9")) (str.to_re "dll?") (re.* re.allchar) (str.to_re "started.feedbackUser-Agent:\u{0a}")))))
; ^0{0,1}[1-9]{1}[0-9]{2}[\s]{0,1}[\-]{0,1}[\s]{0,1}[1-9]{1}[0-9]{6}$
(assert (str.in_re X (re.++ (re.opt (str.to_re "0")) ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "-")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; (@\s*".*?")|("([^"\\]|\\.)*?")
(assert (not (str.in_re X (re.union (re.++ (str.to_re "@") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{22}") (re.* re.allchar) (str.to_re "\u{22}")) (re.++ (str.to_re "\u{0a}\u{22}") (re.* (re.union (re.++ (str.to_re "\u{5c}") re.allchar) (str.to_re "\u{22}") (str.to_re "\u{5c}"))) (str.to_re "\u{22}"))))))
; [0-9]+
(assert (not (str.in_re X (re.++ (re.+ (re.range "0" "9")) (str.to_re "\u{0a}")))))
; mywayHost\x3Awww\x2Eeblocs\x2Ecom
(assert (not (str.in_re X (str.to_re "mywayHost:www.eblocs.com\u{1b}\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
