(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/[a-f0-9]{32}\/[a-f0-9]{32}\u{22}/R
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "\u{22}/R\u{0a}"))))
; uuid=\s+User-Agent\u{3a}\d+\x5Chome\/lordofsearch
(assert (not (str.in_re X (re.++ (str.to_re "uuid=") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:") (re.+ (re.range "0" "9")) (str.to_re "\u{5c}home/lordofsearch\u{0a}")))))
; toolbarplace\x2Ecom\sUser-Agent\u{3a}\d+\x2Fnewsurfer4\x2Fclient=BysooTBADdcww\x2Edmcast\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "toolbarplace.com") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "User-Agent:") (re.+ (re.range "0" "9")) (str.to_re "/newsurfer4/client=BysooTBADdcww.dmcast.com\u{0a}")))))
; /User-Agent\u{3a}[^\u{0d}\u{0a}]*Java\/1\./H
(assert (not (str.in_re X (re.++ (str.to_re "/User-Agent:") (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "Java/1./H\u{0a}")))))
; /filename=[^\n]*\u{2e}smi/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".smi/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
