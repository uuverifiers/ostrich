(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; HXDownload\s+Host\x3AArcadeHourspjpoptwql\u{2f}rlnjFrom\x3A
(assert (str.in_re X (re.++ (str.to_re "HXDownload") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:ArcadeHourspjpoptwql/rlnjFrom:\u{0a}"))))
; ([0-9]{4})-([0-9]{1,2})-([0-9]{1,2})
(assert (not (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; Host\x3A\w+page=largePass-Onseqepagqfphv\u{2f}sfd
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "page=largePass-Onseqepagqfphv/sfd\u{0a}"))))
; /filename=[^\n]*\u{2e}mka/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".mka/i\u{0a}"))))
; User-Agent\x3AHost\u{3a}\u{22}The
(assert (str.in_re X (str.to_re "User-Agent:Host:\u{22}The\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
