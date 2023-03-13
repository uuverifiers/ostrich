(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /(\u{13}\u{00}|\u{00}\x5C)\u{00}m\u{00}q\u{00}r\u{00}t\u{00}\.\u{00}d\u{00}l\u{00}l\u{00}\u{00}\u{00}/i
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "\u{13}\u{00}") (str.to_re "\u{00}\u{5c}")) (str.to_re "\u{00}m\u{00}q\u{00}r\u{00}t\u{00}.\u{00}d\u{00}l\u{00}l\u{00}\u{00}\u{00}/i\u{0a}")))))
; /RegExp?\u{23}.{0,5}\u{28}\u{3f}[^\u{29}]{0,4}i.*?\u{28}\u{3f}\u{2d}[^\u{29}]{0,4}i.{0,50}\u{7c}\u{7c}/smi
(assert (str.in_re X (re.++ (str.to_re "/RegEx") (re.opt (str.to_re "p")) (str.to_re "#") ((_ re.loop 0 5) re.allchar) (str.to_re "(?") ((_ re.loop 0 4) (re.comp (str.to_re ")"))) (str.to_re "i") (re.* re.allchar) (str.to_re "(?-") ((_ re.loop 0 4) (re.comp (str.to_re ")"))) (str.to_re "i") ((_ re.loop 0 50) re.allchar) (str.to_re "||/smi\u{0a}"))))
(check-sat)
