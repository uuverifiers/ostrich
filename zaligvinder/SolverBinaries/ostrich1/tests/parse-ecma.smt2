(set-logic QF_S)

(declare-const w String)

(assert (str.in.re w (re.from.ecma2020 "^[a-zA-Z][a-zA-Z0-9-_\.]{1,20}$")))
(assert (str.in.re w (re.* (re.range "a" "z"))))
(assert (= (str.len w) 5))

(check-sat)
(get-model)


; (Pattern [(Alternative [(AssertionTerm BegAnchor), (AtomTerm (CharClassAtom (PosClass (NonEmptyRangeNN (ClassCharRangeNN (NoDashAtomNN (ClassAtomNoDashNeg1 (ControlLetterNormalChar ControlLettera))) (NoDashAtom (ClassAtomNoDashNeg1 (ControlLetterNormalChar ControlLetterz))) (NonEmptyRange (ClassCharRange (NoDashAtom (ClassAtomNoDashNeg1 (ControlLetterNormalChar ControlLetterA))) (NoDashAtom (ClassAtomNoDashNeg1 (ControlLetterNormalChar ControlLetterZ))) EmptyRange))))))), (AtomQuanTerm (CharClassAtom (PosClass (NonEmptyRangeNN (ClassCharRangeNN (NoDashAtomNN (ClassAtomNoDashNeg1 (ControlLetterNormalChar ControlLettera))) (NoDashAtom (ClassAtomNoDashNeg1 (ControlLetterNormalChar ControlLetterz))) (NonEmptyRange (ClassCharRange (NoDashAtom (ClassAtomNoDashNeg1 (ControlLetterNormalChar ControlLetterA))) (NoDashAtom (ClassAtomNoDashNeg1 (ControlLetterNormalChar ControlLetterZ))) (NonEmptyRange (ClassCharRange (NoDashAtom (ClassAtomNoDashNeg2 ZeroDec)) (NoDashAtom (ClassAtomNoDashNeg2 (PositiveDec "9"))) (NonEmptyRange (ClassCont DashAtom (ClassCont2 (NoDashAtomND (ClassAtomNoDashNeg1 (SpecialLetterNormalChar "_"))) (ClassChar2 (NoDashAtom (ClassAtomNoDashNeg4 (CEClassEscapeCE (IdentityEscape (SyntaxIdentifyEscape (SyntaxCharacter4 SyntaxCharacterSub2)))))))))))))))))) (Quantifier (Loop3Quantifier [(PositiveDec "1")] [(PositiveDec "2"), ZeroDec]))), (AssertionTerm EndAnchor), (AtomTerm (PatternCharAtom (NormalCharPat (SpecialLetterNormalChar "
