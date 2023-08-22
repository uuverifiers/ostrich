(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; X-Mailer\x3A\s+ToolbarScanerX-Mailer\x3AInformation
(assert (not (str.in_re X (re.++ (str.to_re "X-Mailer:\u{13}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ToolbarScanerX-Mailer:\u{13}Information\u{0a}")))))
; \x2Fnewsurfer4\x2FOK\r\nencodertvlistingsTM_SEARCH3
(assert (not (str.in_re X (str.to_re "/newsurfer4/OK\u{0d}\u{0a}encodertvlistingsTM_SEARCH3\u{0a}"))))
; ^(\d{3}-\d{2}-\d{4})|(\d{3}\d{2}\d{4})$
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}") ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 4 4) (re.range "0" "9")))))))
; ^([6011]{4})([0-9]{12})$
(assert (not (str.in_re X (re.++ ((_ re.loop 4 4) (re.union (str.to_re "6") (str.to_re "0") (str.to_re "1"))) ((_ re.loop 12 12) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
