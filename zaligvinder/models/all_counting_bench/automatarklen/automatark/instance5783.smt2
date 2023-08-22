(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\(\?[gimxs]{1,5}\)/
(assert (not (str.in_re X (re.++ (str.to_re "/(?") ((_ re.loop 1 5) (re.union (str.to_re "g") (str.to_re "i") (str.to_re "m") (str.to_re "x") (str.to_re "s"))) (str.to_re ")/\u{0a}")))))
; Subject\u{3a}Porta\x2Fasp\x2Foffers\.asp\?\x2Fiis2ebs\.aspwww\x2Esmileycentral\x2Ecom
(assert (str.in_re X (str.to_re "Subject:Porta/asp/offers.asp?/iis2ebs.aspwww.smileycentral.com\u{0a}")))
; /[^\u{0d}\u{0a}\u{09}\u{20}-\u{7e}]{4}/P
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 4 4) (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}") (str.to_re "\u{09}") (re.range " " "~"))) (str.to_re "/P\u{0a}")))))
; Server\u{00}\s+SbAts\s+versionetbuviaebe\u{2f}eqv\.bvv
(assert (str.in_re X (re.++ (str.to_re "Server\u{00}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "SbAts") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "versionetbuviaebe/eqv.bvv\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
