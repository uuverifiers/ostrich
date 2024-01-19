(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; SpywareinformationToolBarX-Mailer\u{3a}User-Agent\x3AMM_RECO\x2EEXE
(assert (str.in_re X (str.to_re "SpywareinformationToolBarX-Mailer:\u{13}User-Agent:MM_RECO.EXE\u{0a}")))
; dialupvpn\u{5f}pwd\x2Fiis2ebs\.aspOn-Line\x2E\x2E\x2EReport\x2Fnewsurfer4\x2FURLAuthorization\u{3a}
(assert (str.in_re X (str.to_re "dialupvpn_pwd/iis2ebs.aspOn-Line...Report/newsurfer4/URLAuthorization:\u{0a}")))
; ^[D-d][K-k]( |-)[1-9]{1}[0-9]{3}$
(assert (not (str.in_re X (re.++ (re.range "D" "d") (re.range "K" "k") (re.union (str.to_re " ") (str.to_re "-")) ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^((8|\+38)-?)?(\(?044\)?)?-?\d{3}-?\d{2}-?\d{2}$
(assert (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "8") (str.to_re "+38")) (re.opt (str.to_re "-")))) (re.opt (re.++ (re.opt (str.to_re "(")) (str.to_re "044") (re.opt (str.to_re ")")))) (re.opt (str.to_re "-")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
