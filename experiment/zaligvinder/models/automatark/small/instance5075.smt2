(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; DownloadDmInf\x5EinfoSimpsonUser-Agent\x3AClient
(assert (str.in_re X (str.to_re "DownloadDmInf^infoSimpsonUser-Agent:Client\u{0a}")))
; /\u{26}tv\u{3d}\d\.\d\.\d{4}\.\d{4}/smiU
(assert (str.in_re X (re.++ (str.to_re "/&tv=") (re.range "0" "9") (str.to_re ".") (re.range "0" "9") (str.to_re ".") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "/smiU\u{0a}"))))
(check-sat)
