(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; is\x7D\x7BPort\x3A\x7D\x7BUser\x3A
(assert (not (str.in_re X (str.to_re "is}{Port:}{User:\u{0a}"))))
; [0-3]{1}[0-9]{1}(jan|JAN|feb|FEB|mar|MAR|apr|APR|may|MAY|jun|JUN|jul|JUL|aug|AUG|sep|SEP|oct|OCT|nov|NOV|dec|DEC){1}
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "0" "3")) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (str.to_re "jan") (str.to_re "JAN") (str.to_re "feb") (str.to_re "FEB") (str.to_re "mar") (str.to_re "MAR") (str.to_re "apr") (str.to_re "APR") (str.to_re "may") (str.to_re "MAY") (str.to_re "jun") (str.to_re "JUN") (str.to_re "jul") (str.to_re "JUL") (str.to_re "aug") (str.to_re "AUG") (str.to_re "sep") (str.to_re "SEP") (str.to_re "oct") (str.to_re "OCT") (str.to_re "nov") (str.to_re "NOV") (str.to_re "dec") (str.to_re "DEC"))) (str.to_re "\u{0a}"))))
; http\x3A\x2F\x2Ftv\x2Eseekmo\x2Ecom\x2Fshowme\x2Easpx\x3Fkeyword=
(assert (str.in_re X (str.to_re "http://tv.seekmo.com/showme.aspx?keyword=\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
