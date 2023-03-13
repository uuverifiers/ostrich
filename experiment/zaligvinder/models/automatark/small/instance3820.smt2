(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; comLOGUser-Agent\x3Aistsvcwww\x2Eoemji\x2EcomSystemSleuth
(assert (not (str.in_re X (str.to_re "comLOGUser-Agent:istsvcwww.oemji.comSystemSleuth\u{13}\u{0a}"))))
; ^(\d{4},?)+$
(assert (str.in_re X (re.++ (re.+ (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (str.to_re ",")))) (str.to_re "\u{0a}"))))
; ^([1-9]|1[0-2])$
(assert (str.in_re X (re.++ (re.union (re.range "1" "9") (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "\u{0a}"))))
; ^\d{5}(\d{3})?$
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.opt ((_ re.loop 3 3) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; to\s+Host\x3AWeHost\u{3a}
(assert (str.in_re X (re.++ (str.to_re "to") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:WeHost:\u{0a}"))))
(check-sat)
