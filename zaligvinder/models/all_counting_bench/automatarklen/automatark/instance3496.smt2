(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\x2Ewebcruiser\x2Eccgot
(assert (not (str.in_re X (str.to_re "www.webcruiser.ccgot\u{0a}"))))
; url=\swww\x2Ealfacleaner\x2Ecom\d+Host\x3A\x2Fproducts\x2Fspyblocs\x2F
(assert (not (str.in_re X (re.++ (str.to_re "url=") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.alfacleaner.com") (re.+ (re.range "0" "9")) (str.to_re "Host:/products/spyblocs/\u{13}\u{0a}")))))
; /filename=[^\n]*\u{2e}jpx/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".jpx/i\u{0a}"))))
; /RegExp?\u{23}.{0,5}\u{28}\u{3f}[^\u{29}]{0,4}i.*?\u{28}\u{3f}\u{2d}[^\u{29}]{0,4}i.{0,50}\u{7c}\u{7c}/smi
(assert (str.in_re X (re.++ (str.to_re "/RegEx") (re.opt (str.to_re "p")) (str.to_re "#") ((_ re.loop 0 5) re.allchar) (str.to_re "(?") ((_ re.loop 0 4) (re.comp (str.to_re ")"))) (str.to_re "i") (re.* re.allchar) (str.to_re "(?-") ((_ re.loop 0 4) (re.comp (str.to_re ")"))) (str.to_re "i") ((_ re.loop 0 50) re.allchar) (str.to_re "||/smi\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
