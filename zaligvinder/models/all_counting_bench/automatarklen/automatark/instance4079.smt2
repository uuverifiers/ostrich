(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; NSIS_DOWNLOAD.*User-Agent\x3A\s+gpstool\u{2e}globaladserver\u{2e}com
(assert (not (str.in_re X (re.++ (str.to_re "NSIS_DOWNLOAD") (re.* re.allchar) (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "gpstool.globaladserver.com\u{0a}")))))
; ^([0-9]{4})-([0-1][0-9])-([0-3][0-9])\s([0-1][0-9]|[2][0-3]):([0-5][0-9]):([0-5][0-9])$
(assert (not (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "--") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.union (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re "::\u{0a}") (re.range "0" "1") (re.range "0" "9") (re.range "0" "3") (re.range "0" "9") (re.range "0" "5") (re.range "0" "9") (re.range "0" "5") (re.range "0" "9")))))
(assert (> (str.len X) 10))
(check-sat)
