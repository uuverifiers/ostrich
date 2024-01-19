(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\x2Esogou\x2Ecomix=WebsiteHost\u{3a}Web-Mail
(assert (not (str.in_re X (str.to_re "www.sogou.comix=WebsiteHost:Web-Mail\u{0a}"))))
; ohgdhkzfhdzo\u{2f}uwpOK\r\nHost\x3A
(assert (not (str.in_re X (str.to_re "ohgdhkzfhdzo/uwpOK\u{0d}\u{0a}Host:\u{0a}"))))
; (DK-?)?([0-9]{2}\ ?){3}[0-9]{2}
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re "DK") (re.opt (str.to_re "-")))) ((_ re.loop 3 3) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re " ")))) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; Host\x3ASpyxpsp2-Host\u{3a}Host\x3Awjpropqmlpohj\u{2f}loregister\.asp
(assert (str.in_re X (str.to_re "Host:Spyxpsp2-Host:Host:wjpropqmlpohj/loregister.asp\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
