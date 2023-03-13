(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}wrf/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".wrf/i\u{0a}"))))
; /^(\u{00}\u{00}\u{00}\u{00}|.{4}(\u{00}\u{00}\u{00}\u{00}|.{12}))/s
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "\u{00}\u{00}\u{00}\u{00}") (re.++ ((_ re.loop 4 4) re.allchar) (re.union (str.to_re "\u{00}\u{00}\u{00}\u{00}") ((_ re.loop 12 12) re.allchar)))) (str.to_re "/s\u{0a}")))))
(check-sat)
