(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([A-Z]|[a-z]|[0-9])(([A-Z])*(([a-z])*([0-9])*(%)*(&)*(')*(\+)*(-)*(@)*(_)*(\.)*)|(\ )[^  ])+$
(assert (not (str.in_re X (re.++ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9")) (re.+ (re.union (re.++ (re.* (re.range "A" "Z")) (re.* (re.range "a" "z")) (re.* (re.range "0" "9")) (re.* (str.to_re "%")) (re.* (str.to_re "&")) (re.* (str.to_re "'")) (re.* (str.to_re "+")) (re.* (str.to_re "-")) (re.* (str.to_re "@")) (re.* (str.to_re "_")) (re.* (str.to_re "."))) (re.++ (str.to_re " ") (re.comp (str.to_re " "))))) (str.to_re "\u{0a}")))))
; /^\d+O\d+\.jsp\?[a-z0-9\u{3d}\u{2b}\u{2f}]{20}/iR
(assert (str.in_re X (re.++ (str.to_re "/") (re.+ (re.range "0" "9")) (str.to_re "O") (re.+ (re.range "0" "9")) (str.to_re ".jsp?") ((_ re.loop 20 20) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "=") (str.to_re "+") (str.to_re "/"))) (str.to_re "/iR\u{0a}"))))
; cdpView.*protocol.*\x2Fs\u{28}robert\u{40}blackcastlesoft\x2Ecom\u{29}
(assert (not (str.in_re X (re.++ (str.to_re "cdpView") (re.* re.allchar) (str.to_re "protocol") (re.* re.allchar) (str.to_re "/s(robert@blackcastlesoft.com)\u{0a}")))))
; My\x2Fdesktop\x2FWinSessionHost\u{3a}OnlineTPSystem\x7D\x7C
(assert (str.in_re X (str.to_re "My/desktop/WinSessionHost:OnlineTPSystem}|\u{0a}")))
(check-sat)
