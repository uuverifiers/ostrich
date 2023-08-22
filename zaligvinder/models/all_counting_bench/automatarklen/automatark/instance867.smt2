(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; MyAgentprotocolprotocolHost\x3A\x2Fs\u{28}robert\u{40}blackcastlesoft\x2Ecom\u{29}data2\.activshopper\.com
(assert (not (str.in_re X (str.to_re "MyAgentprotocolprotocolHost:/s(robert@blackcastlesoft.com)data2.activshopper.com\u{0a}"))))
; downloads\x2Emorpheus\x2Ecom\x2Frotation
(assert (not (str.in_re X (str.to_re "downloads.morpheus.com/rotation\u{0a}"))))
; ^((\+)?(\d{2}[-])?(\d{10}){1})?(\d{11}){0,1}?$
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.opt (str.to_re "+")) (re.opt (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-"))) ((_ re.loop 1 1) ((_ re.loop 10 10) (re.range "0" "9"))))) (re.opt ((_ re.loop 11 11) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
