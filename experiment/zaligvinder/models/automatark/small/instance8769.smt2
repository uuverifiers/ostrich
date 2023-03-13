(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \u{28}robert\u{40}blackcastlesoft\x2Ecom\u{29}
(assert (not (str.in_re X (str.to_re "(robert@blackcastlesoft.com)\u{0a}"))))
; ^(\()?(787|939)(\)|-)?([0-9]{3})(-)?([0-9]{4}|[0-9]{4})$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "(")) (re.union (str.to_re "787") (str.to_re "939")) (re.opt (re.union (str.to_re ")") (str.to_re "-"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re "-")) (re.union ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 4 4) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; MailerHost\x3AUser-Agent\x3A
(assert (str.in_re X (str.to_re "MailerHost:User-Agent:\u{0a}")))
; HWAE\s+\x2Fta\x2FNEWS\x2FGuptacharloomcompany\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "HWAE") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/ta/NEWS/Guptacharloomcompany.com\u{0a}")))))
(check-sat)
