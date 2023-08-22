(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((\-|d|l|p|s){1}(\-|r|w|x){9})$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 1 1) (re.union (str.to_re "-") (str.to_re "d") (str.to_re "l") (str.to_re "p") (str.to_re "s"))) ((_ re.loop 9 9) (re.union (str.to_re "-") (str.to_re "r") (str.to_re "w") (str.to_re "x"))))))
; download\x2Eeblocs\x2EcomHost\x3AReferer\x3A
(assert (str.in_re X (str.to_re "download.eblocs.comHost:Referer:\u{0a}")))
; /^POST\u{20}\u{2f}g[ao]lfstream\u{26}/
(assert (not (str.in_re X (re.++ (str.to_re "/POST /g") (re.union (str.to_re "a") (str.to_re "o")) (str.to_re "lfstream&/\u{0a}")))))
; \x2Fbar_pl\x2Fshdoclc\.fcgisource%3Dultrasearch136%26campaign%3DsnapEIHBand,
(assert (str.in_re X (str.to_re "/bar_pl/shdoclc.fcgisource%3Dultrasearch136%26campaign%3DsnapEIHBand,\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
