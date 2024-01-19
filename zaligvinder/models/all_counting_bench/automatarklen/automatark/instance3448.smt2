(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3A.*Host\x3A\dName=Your\+Host\+is\x3A
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.* re.allchar) (str.to_re "Host:") (re.range "0" "9") (str.to_re "Name=Your+Host+is:\u{0a}"))))
; vvvjkhmbgnbbw\u{2f}qbn\u{28}robert\u{40}blackcastlesoft\x2Ecom\u{29}
(assert (str.in_re X (str.to_re "vvvjkhmbgnbbw/qbn\u{1b}(robert@blackcastlesoft.com)\u{0a}")))
; (\w+),[^(]+\((\w+)\)\s+(\d+)\s+(\w+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ",") (re.+ (re.comp (str.to_re "("))) (str.to_re "(") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ")") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.range "0" "9")) (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.range "0" "9")) (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.range "0" "9")) (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.range "0" "9")) (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.range "0" "9")) (str.to_re "\u{0a}")))))
; DE\d{2}[ ]\d{4}[ ]\d{4}[ ]\d{4}[ ]\d{4}[ ]\d{2}|DE\d{20}
(assert (str.in_re X (re.++ (str.to_re "DE") (re.union (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ ((_ re.loop 20 20) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
; Keystrokes.*LOG.*Host\x3Awww\x2Eserverlogic3\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Keystrokes") (re.* re.allchar) (str.to_re "LOG") (re.* re.allchar) (str.to_re "Host:www.serverlogic3.com\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
