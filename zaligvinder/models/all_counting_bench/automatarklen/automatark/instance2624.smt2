(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \d{3}-\d{6}
(assert (not (str.in_re X (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /\u{2e}xsl([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.xsl") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; ^((\+44\s?\d{4}|\(?\d{5}\)?)\s?\d{6})|((\+44\s?|0)7\d{3}\s?\d{6})$
(assert (str.in_re X (re.union (re.++ (re.union (re.++ (str.to_re "+44") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (re.opt (str.to_re "(")) ((_ re.loop 5 5) (re.range "0" "9")) (re.opt (str.to_re ")")))) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 6 6) (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}") (re.union (re.++ (str.to_re "+44") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (str.to_re "0")) (str.to_re "7") ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 6 6) (re.range "0" "9"))))))
; /filename=[^\n]*\u{2e}wal/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".wal/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
