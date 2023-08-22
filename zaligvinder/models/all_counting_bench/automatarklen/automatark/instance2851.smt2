(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3ABetaWordixqshv\u{2f}qzccsServer\u{00}
(assert (not (str.in_re X (str.to_re "User-Agent:BetaWordixqshv/qzccsServer\u{00}\u{0a}"))))
; ^[1-9]{1}$|^[1-9]{1}[0-9]{1}$|^[1-3]{1}[0-6]{1}[0-5]{1}$|^365$
(assert (str.in_re X (re.union ((_ re.loop 1 1) (re.range "1" "9")) (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (re.range "1" "3")) ((_ re.loop 1 1) (re.range "0" "6")) ((_ re.loop 1 1) (re.range "0" "5"))) (str.to_re "365\u{0a}"))))
; HXLogOnlyanHost\x3AspasHost\x3A
(assert (not (str.in_re X (str.to_re "HXLogOnlyanHost:spasHost:\u{0a}"))))
; ^0$|^[1-9][0-9]*$|^[1-9][0-9]{0,2}(,[0-9]{3})$
(assert (not (str.in_re X (re.union (str.to_re "0") (re.++ (re.range "1" "9") (re.* (re.range "0" "9"))) (re.++ (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9")) (str.to_re "\u{0a},") ((_ re.loop 3 3) (re.range "0" "9")))))))
; Mirar_KeywordContent
(assert (str.in_re X (str.to_re "Mirar_KeywordContent\u{13}\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
