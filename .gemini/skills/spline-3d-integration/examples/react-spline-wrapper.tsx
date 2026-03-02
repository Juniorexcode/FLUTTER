/*
 * ============================================================================
 * REFERENCE EXAMPLE ONLY — DO NOT IMPORT OR EXECUTE
 * ============================================================================
 * This file is a reference for agents to understand the pattern of a
 * production-ready lazy-loaded Spline wrapper in React/Next.js.
 * It is NOT meant to be compiled, imported, or executed.
 * ============================================================================
 *
 * SplineScene — Production-ready lazy-loaded Spline wrapper
 *
 * Usage:
 *   <SplineScene
 *     scene="https://prod.spline.design/YOUR_ID/scene.splinecode"
 *     className="w-full h-full"
 *     onLoad={(app) => console.log('Ready!', app)}
 *   />
 *
 * Features:
 *   - Lazy loads the ~500KB Spline runtime
 *   - Shows a spinner while loading
 *   - Passes through className and onLoad
 *   - Works in React and Next.js (with 'use client')
 *
 * --- CODE START ---
 *
 * 'use client';
 *
 * import { Suspense, lazy } from 'react';
 *
 * const Spline = lazy(() => import('@splinetool/react-spline'));
 *
 * interface SplineSceneProps {
 *     scene: string;
 *     className?: string;
 *     onLoad?: (app: any) => void;
 * }
 *
 * export function SplineScene({ scene, className, onLoad }: SplineSceneProps) {
 *     return (
 *         <Suspense
 *             fallback={
 *                 <div
 *                     style={{
 *                         width: '100%',
 *                         height: '100%',
 *                         display: 'flex',
 *                         alignItems: 'center',
 *                         justifyContent: 'center',
 *                         background: 'transparent',
 *                     }}
 *                 >
 *                     <LoadingSpinner />
 *                 </div>
 *             }
 *         >
 *             <Spline scene={scene} className={className} onLoad={onLoad} />
 *         </Suspense>
 *     );
 * }
 *
 * function LoadingSpinner() {
 *     return (
 *         <span
 *             style={{
 *                 width: 40,
 *                 height: 40,
 *                 border: '3px solid rgba(255, 255, 255, 0.2)',
 *                 borderTopColor: '#fff',
 *                 borderRadius: '50%',
 *                 animation: 'spline-spin 0.8s linear infinite',
 *             }}
 *         />
 *     );
 * }
 *
 * if (typeof document !== 'undefined') {
 *     const styleId = 'spline-scene-styles';
 *     if (!document.getElementById(styleId)) {
 *         const style = document.createElement('style');
 *         style.id = styleId;
 *         style.textContent = `
 *           @keyframes spline-spin {
 *             to { transform: rotate(360deg); }
 *           }
 *         `;
 *         document.head.appendChild(style);
 *     }
 * }
 *
 * --- CODE END ---
 */
