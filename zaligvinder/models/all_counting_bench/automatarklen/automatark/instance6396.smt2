(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^213\.61\.220\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9][0-9]|[0-9])$
(assert (str.in_re X (re.++ (str.to_re "213.61.220.") (re.union (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "1") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (re.range "1" "9") (re.range "0" "9")) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; stats\u{2e}drivecleaner\u{2e}com\sPARSERInformationurl=Host\x3A
(assert (not (str.in_re X (re.++ (str.to_re "stats.drivecleaner.com\u{13}") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "PARSERInformationurl=Host:\u{0a}")))))
; /\.html\?jar$/U
(assert (str.in_re X (str.to_re "/.html?jar/U\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
