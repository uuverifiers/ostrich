(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; WebsiteUser-Agent\x3Ahttphostfast-look\x2Ecom
(assert (not (str.in_re X (str.to_re "WebsiteUser-Agent:httphostfast-look.com\u{0a}"))))
; ^(\d){8}$
(assert (str.in_re X (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; rank\x2Etoolbarbrowser\x2Ecomlnzzlnbk\u{2f}pkrm\.fin
(assert (not (str.in_re X (str.to_re "rank.toolbarbrowser.comlnzzlnbk/pkrm.fin\u{0a}"))))
; /^\u{2f}[0-9a-z]{30}$/Umi
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 30 30) (re.union (re.range "0" "9") (re.range "a" "z"))) (str.to_re "/Umi\u{0a}")))))
(check-sat)
