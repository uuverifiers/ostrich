(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\x2Esearchreslt\x2Ecom
(assert (str.in_re X (str.to_re "www.searchreslt.com\u{0a}")))
; ^(\+48\s+)?\d{3}(\s*|\-)\d{3}(\s*|\-)\d{3}$
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re "+48") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))) ((_ re.loop 3 3) (re.range "0" "9")) (re.union (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "-")) ((_ re.loop 3 3) (re.range "0" "9")) (re.union (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "-")) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; Server\x3AWordTheHost\u{3a}from
(assert (not (str.in_re X (str.to_re "Server:WordTheHost:from\u{0a}"))))
(check-sat)