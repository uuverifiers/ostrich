(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([a-zA-z\s]{2,})$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "z") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.union (re.range "a" "z") (re.range "A" "z") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))))
; /filename=[^\n]*\u{2e}wsz/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".wsz/i\u{0a}")))))
; User-Agent\x3A\d+PortaURLSSKC\u{7c}roogoo\u{7c}\.cfgmPOPrtCUSTOMPal
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.range "0" "9")) (str.to_re "PortaURLSSKC|roogoo|.cfgmPOPrtCUSTOMPal\u{0a}")))))
; /\.addAnnot\s*\u{28}[^\u{29}]*?points\s*\u{3a}\s*0/i
(assert (str.in_re X (re.++ (str.to_re "/.addAnnot") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "(") (re.* (re.comp (str.to_re ")"))) (str.to_re "points") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ":") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "0/i\u{0a}"))))
; Host\x3A\d+Subject\x3A[^\n\r]*Seconds\-ovplHost\x3AHost\x3ADownload
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.range "0" "9")) (str.to_re "Subject:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Seconds-ovplHost:Host:Download\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
