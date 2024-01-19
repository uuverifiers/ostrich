(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /z\x3D[A-Z0-9%]{700}/i
(assert (str.in_re X (re.++ (str.to_re "/z=") ((_ re.loop 700 700) (re.union (re.range "A" "Z") (re.range "0" "9") (str.to_re "%"))) (str.to_re "/i\u{0a}"))))
; /\u{3f}sv\u{3d}\d{1,3}\u{26}tq\u{3d}/smiU
(assert (str.in_re X (re.++ (str.to_re "/?sv=") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "&tq=/smiU\u{0a}"))))
; ^[A-Za-z]{1}[0-9]{7}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; Server\u{00}\s+SbAts\s+versionetbuviaebe\u{2f}eqv\.bvv
(assert (str.in_re X (re.++ (str.to_re "Server\u{00}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "SbAts") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "versionetbuviaebe/eqv.bvv\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
