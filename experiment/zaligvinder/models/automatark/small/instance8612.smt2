(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3AUser-Agent\u{3a}Host\x3APortScaner
(assert (not (str.in_re X (str.to_re "Host:User-Agent:Host:PortScaner\u{0a}"))))
; ^[D-d][K-k]-[1-9]{1}[0-9]{3}$
(assert (str.in_re X (re.++ (re.range "D" "d") (re.range "K" "k") (str.to_re "-") ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; <!--.*?-->
(assert (not (str.in_re X (re.++ (str.to_re "<!--") (re.* re.allchar) (str.to_re "-->\u{0a}")))))
(check-sat)
