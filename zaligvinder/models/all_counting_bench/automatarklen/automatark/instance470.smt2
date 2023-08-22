(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d{2}[0-1][0-9][0-3][0-9]-{0,1}\d{2}-{0,1}\d{4}$
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.range "0" "1") (re.range "0" "9") (re.range "0" "3") (re.range "0" "9") (re.opt (str.to_re "-")) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /HTTP\/1.[01]\r\nUser\u{2d}Agent\u{3a}\u{20}[ -~]+\r\nHost\u{3a}\u{20}[a-z0-9\u{2d}\u{2e}]+\.info\r\n/
(assert (str.in_re X (re.++ (str.to_re "/HTTP/1") re.allchar (re.union (str.to_re "0") (str.to_re "1")) (str.to_re "\u{0d}\u{0a}User-Agent: ") (re.+ (re.range " " "~")) (str.to_re "\u{0d}\u{0a}Host: ") (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-") (str.to_re "."))) (str.to_re ".info\u{0d}\u{0a}/\u{0a}"))))
; Toolbar\x2Fimages\x2Fnocache\x2Ftr\x2Fgca\x2Fm\.gif\?
(assert (str.in_re X (str.to_re "Toolbar/images/nocache/tr/gca/m.gif?\u{0a}")))
; ^((0?[2])/(0?[1-9]|[1-2][0-9])|(0?[469]|11)/(0?[1-9]|[1-2][0-9]|30)|(0?[13578]|1[02])/(0?[1-9]|[1-2][0-9]|3[0-1]))/([1][9][0-9]{2}|[2-9][0-9]{3}) (00|0?[1-9]|1[0-9]|2[0-3])\:([0-5][0-9])\:([0-5][0-9])$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "/") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.range "1" "2") (re.range "0" "9"))) (re.opt (str.to_re "0")) (str.to_re "2")) (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.union (str.to_re "4") (str.to_re "6") (str.to_re "9"))) (str.to_re "11")) (str.to_re "/") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.range "1" "2") (re.range "0" "9")) (str.to_re "30"))) (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "8"))) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "2")))) (str.to_re "/") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.range "1" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))))) (str.to_re "/") (re.union (re.++ (str.to_re "19") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (re.range "2" "9") ((_ re.loop 3 3) (re.range "0" "9")))) (str.to_re " ") (re.union (str.to_re "00") (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re "::\u{0a}") (re.range "0" "5") (re.range "0" "9") (re.range "0" "5") (re.range "0" "9"))))
(assert (> (str.len X) 10))
(check-sat)
