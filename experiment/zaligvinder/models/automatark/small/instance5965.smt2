(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([^:])+\\.([^:])+$
(assert (str.in_re X (re.++ (re.+ (re.comp (str.to_re ":"))) (str.to_re "\u{5c}") re.allchar (re.+ (re.comp (str.to_re ":"))) (str.to_re "\u{0a}"))))
; Spy\s+\u{0d}\u{0a}.*YAHOOdestroyed\u{21}Host\u{3a}
(assert (not (str.in_re X (re.++ (str.to_re "Spy") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0d}\u{0a}") (re.* re.allchar) (str.to_re "YAHOOdestroyed!Host:\u{0a}")))))
; ^\d{0,2}(\.\d{1,2})?$
(assert (str.in_re X (re.++ ((_ re.loop 0 2) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; \x7D\x7BTrojan\x3Abacktrust\x2EcomHost\x3Apjpoptwql\u{2f}rlnj
(assert (not (str.in_re X (str.to_re "}{Trojan:backtrust.comHost:pjpoptwql/rlnj\u{0a}"))))
; vvvjkhmbgnbbw\u{2f}qbn\u{28}robert\u{40}blackcastlesoft\x2Ecom\u{29}
(assert (str.in_re X (str.to_re "vvvjkhmbgnbbw/qbn\u{1b}(robert@blackcastlesoft.com)\u{0a}")))
(check-sat)
