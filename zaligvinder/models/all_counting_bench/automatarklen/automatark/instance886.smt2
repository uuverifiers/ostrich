(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ((^\d{5}$)|(^\d{8}$))|(^\d{5}-\d{3}$)
(assert (str.in_re X (re.union (re.++ (str.to_re "\u{0a}") ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9"))) ((_ re.loop 5 5) (re.range "0" "9")) ((_ re.loop 8 8) (re.range "0" "9")))))
; cdpView.*protocol.*\x2Fs\u{28}robert\u{40}blackcastlesoft\x2Ecom\u{29}
(assert (str.in_re X (re.++ (str.to_re "cdpView") (re.* re.allchar) (str.to_re "protocol") (re.* re.allchar) (str.to_re "/s(robert@blackcastlesoft.com)\u{0a}"))))
; Host\x3A\w+User-Agent\x3A\sTeomaBarHost\x3AHoursHost\x3AHost\x3A
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "User-Agent:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "TeomaBarHost:HoursHost:Host:\u{0a}"))))
; /\/software\u{2e}php\u{3f}[0-9]{15,}/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//software.php?/Ui\u{0a}") ((_ re.loop 15 15) (re.range "0" "9")) (re.* (re.range "0" "9"))))))
(assert (> (str.len X) 10))
(check-sat)
