(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Subject\x3A\s+www\u{2e}proventactics\u{2e}comdownloads\x2Emorpheus\x2Ecom\x2Frotation
(assert (not (str.in_re X (re.++ (str.to_re "Subject:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.proventactics.comdownloads.morpheus.com/rotation\u{0a}")))))
; (W(5|6)[D]?\-\d{9})|(W1\-\d{9}(\-\d{2})?)
(assert (str.in_re X (re.union (re.++ (str.to_re "W") (re.union (str.to_re "5") (str.to_re "6")) (re.opt (str.to_re "D")) (str.to_re "-") ((_ re.loop 9 9) (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}W1-") ((_ re.loop 9 9) (re.range "0" "9")) (re.opt (re.++ (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9"))))))))
; ^([1][0-9]|[0-9])[1-9]{2}$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "1") (re.range "0" "9")) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "1" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
