(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\d{5})[\.\-\+ ]?(\d{4})?
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.opt (re.union (str.to_re ".") (str.to_re "-") (str.to_re "+") (str.to_re " "))) (re.opt ((_ re.loop 4 4) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; SpywareStrike.*Subject\x3A\s+Pcast\x2Edat\x2EToolbar
(assert (str.in_re X (re.++ (str.to_re "SpywareStrike") (re.* re.allchar) (str.to_re "Subject:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Pcast.dat.Toolbar\u{0a}"))))
; ^[^']*$
(assert (not (str.in_re X (re.++ (re.* (re.comp (str.to_re "'"))) (str.to_re "\u{0a}")))))
(check-sat)
